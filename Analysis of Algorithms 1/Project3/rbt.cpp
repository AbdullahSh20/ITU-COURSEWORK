// Abdullah Jafar Manosur Shamout
// 150200919
// Implementing Red-Black Tree in C++

#include <iostream>

namespace RBT
{
  struct Node
  {
    int data;
    std::string name;
    Node *parent;
    Node *left;
    Node *right;
    int color; // color 0 is black, color 1 is red

    Node(int val, const std::string &name, Node *parent = nullptr, Node *left = nullptr, Node *right = nullptr, int color = 1)
        : data(val), name(name), parent(parent), left(left), right(right), color(color) {} // Constructor with initializer list to initialize the node, used in insert
  };
}

typedef RBT::Node *RBTnodePtr; // defining a new type that is a pointer to a node, instead of writing BST::Node * every time we can just write RBTnodePtr
class RedBlackTree
{
public:
  RedBlackTree() : root(nullptr) {} // Constructor for the tree to initialize the root to nullptr using initializer list
  ~RedBlackTree()                   // destructor that deletes the tree
  {
    deleteTree(this->root);
  }

  void preorder() // public function that calls the private preorder backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    preOrderBackend(this->root);
  }

  void preorder(std::pair<std::string, int> data[], int dataLength) // public function that calls the private preorder backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    preOrderBackend(this->root, data, dataLength);
  }

  void inorder() // public function that calls the private inorder backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    inOrderBackend(this->root);
  }

  void inorder(std::pair<std::string, int> data[], int dataLength) // public function that calls the private inorder backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    inOrderBackend(this->root, data, dataLength);
  }

  void postorder() // public function that calls the private postorder backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    postOrderBackend(this->root);
  }

  void postorder(std::pair<std::string, int> data[], int dataLength) // public function that calls the private postorder backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    postOrderBackend(this->root, data, dataLength);
  }

  RBTnodePtr searchTree(const int &key) // public function that calls the private searchTree backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return searchTreeBackend(this->root, key);
  }

  RBTnodePtr successor(RBTnodePtr currentNode) // public function that calls the private successor backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return successorBackend(currentNode);
  }

  RBTnodePtr predecessor(RBTnodePtr currentNode) // public function that calls the private predecessor backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return predecessorBackend(currentNode);
  }

  void insert(std::string name, int key) // public function that calls the private insert backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    insertBackend(name, key);
  }

  void deleteNode(int key) // public function that calls the private deleteNode backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    deleteNodeBackend(key);
  }

  int getHeight() // public function that calls the private getHeight backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return getHeightBackend(this->root);
  }

  RBTnodePtr getMaximum() // public function that calls the private maximum backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return maximumBackend(this->root);
  }

  RBTnodePtr getMinimum() // public function that calls the private minimum backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return minimumBackend(this->root);
  }

  int getTotalNodes() // public function that calls the private totalNodes backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return totalNodesBackend(this->root);
  }

private:           // private members of the class are shown first in the structure given, since we were taught in OOP that public comes first, and this is an OOP structure, I am following the standards by making public come first
  RBTnodePtr root; // creating the root of the tree which is private, following OOP standards

  // Preorder backend function that takes a node pointer as an argument and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void preOrderBackend(RBTnodePtr node)
  {
    if (node != nullptr) // if the node is not null, print the data, then call the function recursively on the left and right children
    {
      std::cout << "city: " << node->name << " population: " << node->data << "\n"; // printing the data
      preOrderBackend(node->left);                                                  // calling the function recursively on the left child
      preOrderBackend(node->right);                                                 // calling the function recursively on the right child
    }
  }

  // overloading the backend preorder function to be callable from main to store the ordered list of cities and populations, and return in pair<string, int> array
  void preOrderBackend(RBTnodePtr node, std::pair<std::string, int> data[], int &dataLength)
  {
    if (node != nullptr) // if the node is not null, print the data, then call the function recursively on the left and right children
    {
      data[dataLength++] = std::make_pair(node->name, node->data); // storing the data in the array
      preOrderBackend(node->left, data, dataLength);               // calling the function recursively on the left child
      preOrderBackend(node->right, data, dataLength);              // calling the function recursively on the right child
    }
  }

  // Inorder backend function that takes a node pointer as an argument and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void inOrderBackend(RBTnodePtr node)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then print the data, then call the function recursively on the right child
    {
      inOrderBackend(node->left);                                                   // calling the function recursively on the left child
      std::cout << "city: " << node->name << " population: " << node->data << "\n"; // printing the data
      inOrderBackend(node->right);                                                  // calling the function recursively on the right child
    }
  }

  // overloading the backend inorder function to be callable from main to store the ordered list of cities and populations, and return in pair<string, int> array
  void inOrderBackend(RBTnodePtr node, std::pair<std::string, int> data[], int &dataLength)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then store the data in the array, then call the function recursively on the right child
    {
      inOrderBackend(node->left, data, dataLength);                // calling the function recursively on the left child
      data[dataLength++] = std::make_pair(node->name, node->data); // storing the data in the array
      inOrderBackend(node->right, data, dataLength);               // calling the function recursively on the right child
    }
  }

  // Postorder backend function that takes a node pointer as an argument and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void postOrderBackend(RBTnodePtr node)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then call the function recursively on the right child, then print the data
    {
      postOrderBackend(node->left);                                                 // calling the function recursively on the left child
      postOrderBackend(node->right);                                                // calling the function recursively on the right child
      std::cout << "city: " << node->name << " population: " << node->data << "\n"; // printing the data
    }
  }

  // overloading the backend postorder function to be callable from main to store the ordered list of cities and populations, and return in pair<string, int> array
  void postOrderBackend(RBTnodePtr node, std::pair<std::string, int> data[], int &dataLength)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then call the function recursively on the right child, then store the data in the array
    {
      postOrderBackend(node->left, data, dataLength);              // calling the function recursively on the left child
      postOrderBackend(node->right, data, dataLength);             // calling the function recursively on the right child
      data[dataLength++] = std::make_pair(node->name, node->data); // storing the data in the array
    }
  }

  // totalNodes backend function that takes a node pointer as an argument and returns an integer. This function is private and is only called by the public functions that act as an API in the OOP sense
  int totalNodesBackend(RBTnodePtr node)
  {
    if (node == nullptr) // if the node is null, return 0 since there are no nodes to add to the total
      return 0;

    int left = totalNodesBackend(node->left);   // calling the function recursively on the left child
    int right = totalNodesBackend(node->right); // calling the function recursively on the right child

    return left + right + 1; // returning the total number of nodes
  }

  // maximum backend function that takes a node pointer as an argument and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  RBTnodePtr maximumBackend(RBTnodePtr node)
  {
    while (node->right != nullptr) // while the right child is not null, keep going right. since its a BST, the rightmost node will be the maximum
    {
      node = node->right;
    }
    return node;
  }

  // minimum backend function that takes a node pointer as an argument and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  RBTnodePtr minimumBackend(RBTnodePtr node)
  {
    while (node->left != nullptr) // while the left child is not null, keep going left. since its a BST, the leftmost node will be the minimum
    {
      node = node->left;
    }
    return node;
  }

  // getHeight backend function that takes a node pointer as an argument and returns an integer. This function is private and is only called by the public functions that act as an API in the OOP sense
  int getHeightBackend(RBTnodePtr node)
  {
    if (node == nullptr) // if the node is null, return -1 since there are no nodes to add to the total and the height is the number of edges from the root to the deepest leaf
      return -1;

    int left = getHeightBackend(node->left);   // calling the function recursively on the left child
    int right = getHeightBackend(node->right); // calling the function recursively on the right child

    if (left > right) // if the left height is greater than the right height, return the left height + 1
      return left + 1;
    else // else return the right height + 1
      return right + 1;
  }

  // successor backend function that takes a node pointer as an argument and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  RBTnodePtr successorBackend(RBTnodePtr currentNode)
  {
    if (currentNode->right != nullptr) // if the right child is not null, then the successor is the minimum of the right subtree
    {
      return minimumBackend(currentNode->right);
    }
    else
    {
      RBTnodePtr parentNode = currentNode->parent; // else the successor is the lowest ancestor of the current node whose left child is also an ancestor of the current node

      while (parentNode != nullptr && currentNode == parentNode->right) // while the parent node is not null meaning not root, and the current node is the right child of the parent node, keep going up
      {
        currentNode = parentNode;        // set the current node to the parent node
        parentNode = parentNode->parent; // set the parent node to the parent of the parent node
      }

      return parentNode; // return the parent node
    }
  }

  // predecessor backend function that takes a node pointer as an argument and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  RBTnodePtr predecessorBackend(RBTnodePtr currentNode)
  {
    if (currentNode->left != nullptr) // if the left child is not null, then the predecessor is the maximum of the left subtree
    {
      return maximumBackend(currentNode->left);
    }
    else
    {
      RBTnodePtr parentNode = currentNode->parent; // else the predecessor is the lowest ancestor of the current node whose right child is also an ancestor of the current node

      while (parentNode != nullptr && currentNode == parentNode->left) // while the parent node is not null meaning not root, and the current node is the left child of the parent node, keep going up
      {
        currentNode = parentNode;        // set the current node to the parent node
        parentNode = parentNode->parent; // set the parent node to the parent of the parent node
      }

      return parentNode; // return the parent node
    }
  }

  // searchTree backend function that takes a node pointer and an integer key as arguments and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  RBTnodePtr searchTreeBackend(RBTnodePtr node, const int &key)
  {
    if (node == nullptr || key == node->data) // if the node is null or the key is equal to the data in the node, return the node. If the node is null, the key is not in the tree
    {
      return node;
    }

    if (key < node->data) // if the key is less than the data in the node, call the function recursively on the left child
    {
      return searchTreeBackend(node->left, key);
    }
    else // if the key is greater than the data in the node, call the function recursively on the right child
    {
      return searchTreeBackend(node->right, key);
    }
  }

  // Performs a left rotation on the red-black tree rooted at node 'currentNode'
  void leftRotate(RBTnodePtr currentNode)
  {
    RBTnodePtr rightChild = currentNode->right; // Set 'rightChild' as the right child of 'currentNode'

    // Update right child of 'currentNode' to be the left child of 'rightChild'
    currentNode->right = rightChild->left;

    // Update parent pointer of 'rightChild's left child, if it exists
    if (rightChild->left != nullptr)
    {
      rightChild->left->parent = currentNode;
    }

    rightChild->parent = currentNode->parent; // Update 'rightChild's parent to be 'currentNode's parent

    // Update the root if 'currentNode' was the root
    if (currentNode->parent == nullptr)
    {
      this->root = rightChild;
    }
    // Update the parent's left child if 'currentNode' was the left child
    else if (currentNode == currentNode->parent->left)
    {
      currentNode->parent->left = rightChild;
    }
    // Update the parent's right child if 'currentNode' was the right child
    else
    {
      currentNode->parent->right = rightChild;
    }

    rightChild->left = currentNode;   // Set 'currentNode' as the left child of 'rightChild'
    currentNode->parent = rightChild; // Update 'currentNode's parent to be 'rightChild'
  }

  // A function that performs right rotation on the red-black tree from 'currentNode'
  void rightRotate(RBTnodePtr currentNode)
  {
    RBTnodePtr leftChild = currentNode->left; // Set 'leftChild' as the left child of 'currentNode'

    // Update left child of 'currentNode' to be the right child of 'leftChild'
    currentNode->left = leftChild->right;

    // Update parent pointer of 'leftChild's right child, if it exists
    if (leftChild->right != nullptr)
    {
      leftChild->right->parent = currentNode;
    }

    leftChild->parent = currentNode->parent; // Update 'leftChild's parent to be 'currentNode's parent

    // Update the root if 'currentNode' was the root
    if (currentNode->parent == nullptr)
    {
      this->root = leftChild;
    }
    // Update the parent's right child if 'currentNode' was the right child
    else if (currentNode == currentNode->parent->right)
    {
      currentNode->parent->right = leftChild;
    }
    // Update the parent's left child if 'currentNode' was the left child
    else
    {
      currentNode->parent->left = leftChild;
    }

    leftChild->right = currentNode;  // Set 'currentNode' as the right child of 'leftChild'
    currentNode->parent = leftChild; // Update 'currentNode's parent to be 'leftChild'
  }

  // A function that balances the red-black tree after insertion to maintain its properties.
  void insertBalance(RBTnodePtr newNode)
  {
    RBTnodePtr uncle;

    while (newNode->parent != nullptr && newNode->parent->color == 1)
    {
      // Determine the side of the parent relative to its grandparent.
      if (newNode->parent == newNode->parent->parent->right)
      {
        uncle = newNode->parent->parent->left;

        // Case 1: Uncle is also red; recolor and move up the tree.
        if (uncle != nullptr && uncle->color == 1)
        {
          uncle->color = 0;
          newNode->parent->color = 0;
          newNode->parent->parent->color = 1;
          newNode = newNode->parent->parent;
        }
        // Case 2: Uncle is black; perform rotations and recolor.
        else
        {
          if (newNode == newNode->parent->left)
          {
            newNode = newNode->parent;
            rightRotate(newNode);
          }

          newNode->parent->color = 0;
          newNode->parent->parent->color = 1;
          leftRotate(newNode->parent->parent);
        }
      }
      // Doing the same cases as above cases for the left side.
      else
      {
        uncle = newNode->parent->parent->right;

        // Case 1: Uncle is also red; recolor and move up the tree.
        if (uncle != nullptr && uncle->color == 1)
        {
          uncle->color = 0;
          newNode->parent->color = 0;
          newNode->parent->parent->color = 1;
          newNode = newNode->parent->parent;
        }
        // Case 2: Uncle is black; perform rotations and recolor.
        else
        {
          if (newNode == newNode->parent->right)
          {
            newNode = newNode->parent;
            leftRotate(newNode);
          }

          newNode->parent->color = 0;
          newNode->parent->parent->color = 1;
          rightRotate(newNode->parent->parent);
        }
      }

      // Break out of the loop if the current node is the root.
      if (newNode == root)
      {
        break;
      }
    }
    // Making sure the root is black.
    root->color = 0;
  }

  // insert backend function that takes a string name and an integer key as arguments and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void insertBackend(std::string name, int key)
  {
    RBTnodePtr node = new RBT::Node(key, name); // creating a new node with the key and name

    RBTnodePtr possibleParent = nullptr; // creating a node pointer possibleParent that will be used to keep track of the parent of the node we are inserting
    RBTnodePtr currentNode = this->root; // creating a node pointer currentNode that will be used to traverse the tree

    while (currentNode != nullptr) // while currentNode is not null, keep going down the tree
    {
      possibleParent = currentNode;       // set possibleParent to currentNode
      if (node->data < currentNode->data) // if the key of the node we are inserting is less than the key of the current node, go left
      {
        currentNode = currentNode->left;
      }
      else // else go right
      {
        currentNode = currentNode->right;
      }
    }

    node->parent = possibleParent; // set the parent of the node we are inserting to possibleParent

    if (possibleParent == nullptr) // if possibleParent is null, that means the tree was empty, thus the node we are inserting is the root
    {
      root = node;
    }
    else if (node->data < possibleParent->data) // else if the key of the node we are inserting is less than the key of the parent, make the node we are inserting the left child of the parent
    {
      possibleParent->left = node;
    }
    else // else make the node we are inserting the right child of the parent
    {
      possibleParent->right = node;
    }

    if (node->parent == nullptr) // if the parent of the node we are inserting is null, that means the node we are inserting is the root, thus we color it black
    {
      node->color = 0;
      return;
    }

    if (node->parent->parent == nullptr) // if the grandparent of the node we are inserting is null, that means the node we are inserting is the child of the root, thus we return since we don't need to balance
    {
      return;
    }

    insertBalance(node); // call the insertBalance function on the node
  }

  // transplant function that takes two node pointers as arguments and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void transplant(RBTnodePtr currentNode, RBTnodePtr replacementNode)
  {
    if (currentNode->parent == nullptr) // if the parent of the current node is null, that means it was the root, thus the replacement will be the root
    {
      root = replacementNode;
    }
    else if (currentNode == currentNode->parent->left) // else if the current node was a left child, then the left child will be the replacement
    {
      currentNode->parent->left = replacementNode;
    }
    else
    {
      currentNode->parent->right = replacementNode; // else the right child will be the replacement
    }
    if (replacementNode != nullptr) // if the replacement node is not refrencing a null pointer, then do the connection to the deleted nodes parent
    {
      replacementNode->parent = currentNode->parent;
    }
  }

  // Balances the red-black tree after deletion to maintain its properties
  void deleteBalance(RBTnodePtr currentNode)
  {
    RBTnodePtr sibling;

    while (currentNode != root && currentNode->color == 0 && currentNode != nullptr)
    {
      // Determine the side of the current node relative to its parent.
      if (currentNode == currentNode->parent->left)
      {
        sibling = currentNode->parent->right; // Set 'sibling' as the sibling of 'currentNode'

        // Case 1: Sibling is red; recolor and perform a left rotation.
        if (sibling != nullptr && sibling->color == 1)
        {
          sibling->color = 0;
          currentNode->parent->color = 1;
          leftRotate(currentNode->parent);
          sibling = currentNode->parent->right;
        }

        // Case 2: Both children of the sibling are black; recolor and move up the tree.
        if (sibling != nullptr && sibling->left != nullptr && sibling->right != nullptr && sibling->left->color == 0 && sibling->right->color == 0)
        {
          sibling->color = 1;
          currentNode = currentNode->parent;
        }
        else
        {
          // Case 3: Right child of sibling is black; recolor and perform a right rotation.
          if (sibling != nullptr && sibling->right != nullptr && sibling->right->color == 0)
          {
            sibling->left->color = 0;
            sibling->color = 1;
            rightRotate(sibling);
            sibling = currentNode->parent->right;
          }
          // Case 4: Left child of sibling is black; recolor and perform a left rotation.
          else
          {
            if (sibling != nullptr)
            {
              sibling->color = currentNode->parent->color;
              currentNode->parent->color = 0;
              if (sibling->right != nullptr)
                sibling->right->color = 0;
              leftRotate(currentNode->parent);
            }
            currentNode = root;
          }
        }
      }
      else
      {
        // same cases as above but for the right side
        sibling = currentNode->parent->left;

        if (sibling != nullptr && sibling->color == 1)
        {
          sibling->color = 0;
          currentNode->parent->color = 1;
          rightRotate(currentNode->parent);
          sibling = currentNode->parent->left;
        }

        if (sibling != nullptr && sibling->right != nullptr && sibling->left != nullptr && sibling->right->color == 0 && sibling->left->color == 0)
        {
          sibling->color = 1;
          currentNode = currentNode->parent;
        }
        else
        {
          if (sibling != nullptr && sibling->left != nullptr && sibling->left->color == 0)
          {
            sibling->right->color = 0;
            sibling->color = 1;
            leftRotate(sibling);
            sibling = currentNode->parent->left;
          }
          else
          {
            if (sibling != nullptr)
            {
              sibling->color = currentNode->parent->color;
              currentNode->parent->color = 0;
              if (sibling->left != nullptr)
                sibling->left->color = 0;
              rightRotate(currentNode->parent);
            }
            currentNode = root;
          }
        }
      }
    }

    currentNode->color = 0; // Ensure the root is black.
  }

  void deleteNodeBackend(int key)
  {
    RBTnodePtr targetNode = nullptr;
    RBTnodePtr successor, replacementNode;

    // Search for the node with the given key
    targetNode = searchTreeBackend(this->root, key);

    if (targetNode == nullptr)
    {
      std::cout << "Key " << key << " is not in the tree. Thus deleting is impossible" << std::endl;
      return;
    }

    successor = targetNode;
    int successorOriginalColor = successor->color;

    // Determine the replacement node based on the target node's children
    if (targetNode->left == nullptr)
    {
      // If the left child is null, set the replacement as the right child and perform transplant
      replacementNode = targetNode->right;
      if (replacementNode != nullptr)
      {
        transplant(targetNode, targetNode->right);
      }
      else
      {
        // If replacementNode is null, update parent pointers of targetNode
        if (targetNode->parent != nullptr)
        {
          if (targetNode->parent->left == targetNode)
          {
            targetNode->parent->left = nullptr;
          }
          else
          {
            targetNode->parent->right = nullptr;
          }
        }
      }
    }
    else if (targetNode->right == nullptr)
    {
      // If the right child is null, set the replacement as the left child and perform transplant
      replacementNode = targetNode->left;
      if (replacementNode != nullptr)
      {
        transplant(targetNode, targetNode->left);
      }
      else
      {
        // If replacementNode is null, update parent pointers of targetNode
        if (targetNode->parent != nullptr)
        {
          if (targetNode->parent->left == targetNode)
          {
            targetNode->parent->left = nullptr;
          }
          else
          {
            targetNode->parent->right = nullptr;
          }
        }
      }
    }
    else
    {
      // If both children are present, find the successor and set it as the replacement
      successor = minimumBackend(targetNode->right);
      successorOriginalColor = successor->color;
      replacementNode = successor->right;

      // If the successor is the right child of the target node, update its parent
      if (successor->parent == targetNode)
      {
        if (replacementNode != nullptr)
        {
          replacementNode->parent = successor;
        }
      }
      else
      {
        // else, perform transplant to replace the successor with its right child
        transplant(successor, successor->right);
        successor->right = targetNode->right;
        if (successor->right != nullptr)
        {
          successor->right->parent = successor;
        }
      }

      // Perform transplant to replace the target node with the successor
      transplant(targetNode, successor);
      successor->left = targetNode->left;
      if (successor->left != nullptr)
      {
        successor->left->parent = successor;
      }
      successor->color = targetNode->color;
    }

    // Delete the target node
    delete targetNode;

    // If the original color of the successor node was black, fix the tree
    if (successorOriginalColor == 0)
    {
      if (replacementNode != nullptr)
      {
        deleteBalance(replacementNode);
      }
    }
  }

  void deleteTree(RBTnodePtr node) // private function that recursively deletes the tree
  {
    if (node != nullptr) // if the node is not null
    {
      deleteTree(node->left);  // recursively delete the left subtree
      deleteTree(node->right); // recursively delete the right subtree
      delete node;             // delete the current node
    }
  }
};