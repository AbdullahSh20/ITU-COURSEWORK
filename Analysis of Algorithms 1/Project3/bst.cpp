// Abdullah Jafar Manosur Shamout
// 150200919
// Implementing Binary Search Tree in C++

#include <iostream>
namespace BST
{
  struct Node
  {
    int data;
    std::string name;
    Node *parent;
    Node *left;
    Node *right;

    Node(int val, const std::string &name, Node *parent = nullptr, Node *left = nullptr, Node *right = nullptr)
        : data(val), name(name), parent(parent), left(left), right(right) {} // Constructor with initializer list to initialize the node, used in insert
  };
}

typedef BST::Node *BSTnodePtr; // defining a new type that is a pointer to a node, instead of writing BST::Node * every time we can just write BSTnodePtr
class BinarySearchTree
{
public:                                 // changed the given order since in OOP standards the public members should come first instead of the private
  BinarySearchTree() : root(nullptr) {} // Constructor for the tree to initialize the root to nullptr using initializer list
  ~BinarySearchTree()                   // Destructor for the tree to delete all the nodes in the tree and free up memory
  {
    while (root != nullptr) // while the root is not null, keep deleting the root
    {
      deleteNode(root->data);
    }
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

  BSTnodePtr searchTree(const int &key) // public function that calls the private searchTree backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return searchTreeBackend(this->root, key);
  }

  BSTnodePtr successor(BSTnodePtr currentNode) // public function that calls the private successor backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return successorBackend(currentNode);
  }

  BSTnodePtr predecessor(BSTnodePtr currentNode) // public function that calls the private predecessor backend function, it acts as an API to the functionality that is private in an OOP sense
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

  BSTnodePtr getMaximum() // public function that calls the private maximum backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return maximumBackend(this->root);
  }

  BSTnodePtr getMinimum() // public function that calls the private minimum backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return minimumBackend(this->root);
  }

  int getTotalNodes() // public function that calls the private totalNodes backend function, it acts as an API to the functionality that is private in an OOP sense
  {
    return totalNodesBackend(this->root);
  }

private:           // private members of the class are shown first in the structure given, but since this is OOP structure, the public members should come first which is why I changed the order
  BSTnodePtr root; // creating the root of the tree which is private, following OOP standards

  // Preorder backend function that takes a node pointer as an argument and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void preOrderBackend(BSTnodePtr node)
  {
    if (node != nullptr) // if the node is not null, print the data, then call the function recursively on the left and right children
    {
      std::cout << "city: " << node->name << " population: " << node->data << "\n"; // printing the data
      preOrderBackend(node->left);                                                  // calling the function recursively on the left child
      preOrderBackend(node->right);                                                 // calling the function recursively on the right child
    }
  }

  // overloading the backend preorder function to be callable from main to store the ordered list of cities and populations, and return in pair<string, int> array
  void preOrderBackend(BSTnodePtr node, std::pair<std::string, int> data[], int &dataLength)
  {
    if (node != nullptr) // if the node is not null, store the data in the array, then call the function recursively on the left and right children
    {
      data[dataLength++] = std::make_pair(node->name, node->data); // storing the data in the array
      preOrderBackend(node->left, data, dataLength);               // calling the function recursively on the left child
      preOrderBackend(node->right, data, dataLength);              // calling the function recursively on the right child
    }
  }

  // Inorder backend function that takes a node pointer as an argument and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void inOrderBackend(BSTnodePtr node)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then print the data, then call the function recursively on the right child
    {
      inOrderBackend(node->left);                                                   // calling the function recursively on the left child
      std::cout << "city: " << node->name << " population: " << node->data << "\n"; // printing the data
      inOrderBackend(node->right);                                                  // calling the function recursively on the right child
    }
  }

  // overloading the backend inorder function to be callable from main to store the ordered list of cities and populations, and return in pair<string, int> array
  void inOrderBackend(BSTnodePtr node, std::pair<std::string, int> data[], int &dataLength)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then store the data in the array, then call the function recursively on the right child
    {
      inOrderBackend(node->left, data, dataLength);                // calling the function recursively on the left child
      data[dataLength++] = std::make_pair(node->name, node->data); // storing the data in the array
      inOrderBackend(node->right, data, dataLength);               // calling the function recursively on the right child
    }
  }

  // Postorder backend function that takes a node pointer as an argument and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void postOrderBackend(BSTnodePtr node)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then call the function recursively on the right child, then print the data
    {
      postOrderBackend(node->left);                                                 // calling the function recursively on the left child
      postOrderBackend(node->right);                                                // calling the function recursively on the right child
      std::cout << "city: " << node->name << " population: " << node->data << "\n"; // printing the data
    }
  }

  // overloading the backend postorder function to be callable from main to store the ordered list of cities and populations, and return in pair<string, int> array
  void postOrderBackend(BSTnodePtr node, std::pair<std::string, int> data[], int &dataLength)
  {
    if (node != nullptr) // if the node is not null, call the function recursively on the left child, then call the function recursively on the right child, then store the data in the array
    {
      postOrderBackend(node->left, data, dataLength);              // calling the function recursively on the left child
      postOrderBackend(node->right, data, dataLength);             // calling the function recursively on the right child
      data[dataLength++] = std::make_pair(node->name, node->data); // storing the data in the array
    }
  }

  // totalNodes backend function that takes a node pointer as an argument and returns an integer. This function is private and is only called by the public functions that act as an API in the OOP sense
  int totalNodesBackend(BSTnodePtr node)
  {
    if (node == nullptr) // if the node is null, return 0 since there are no nodes to add to the total
      return 0;

    int left = totalNodesBackend(node->left);   // calling the function recursively on the left child
    int right = totalNodesBackend(node->right); // calling the function recursively on the right child

    return left + right + 1; // returning the total number of nodes
  }

  // maximum backend function that takes a node pointer as an argument and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  BSTnodePtr maximumBackend(BSTnodePtr node)
  {
    while (node->right != nullptr) // while the right child is not null, keep going right. since its a BST, the rightmost node will be the maximum
    {
      node = node->right;
    }
    return node;
  }

  // minimum backend function that takes a node pointer as an argument and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  BSTnodePtr minimumBackend(BSTnodePtr node)
  {
    while (node->left != nullptr) // while the left child is not null, keep going left. since its a BST, the leftmost node will be the minimum
    {
      node = node->left;
    }
    return node;
  }

  // getHeight backend function that takes a node pointer as an argument and returns an integer. This function is private and is only called by the public functions that act as an API in the OOP sense
  int getHeightBackend(BSTnodePtr node)
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
  BSTnodePtr successorBackend(BSTnodePtr currentNode)
  {
    if (currentNode->right != nullptr) // if the right child is not null, then the successor is the minimum of the right subtree
    {
      return minimumBackend(currentNode->right);
    }
    else
    {
      BSTnodePtr parentNode = currentNode->parent; // else the successor is the lowest ancestor of the current node whose left child is also an ancestor of the current node

      while (parentNode != nullptr && currentNode == parentNode->right) // while the parent node is not null meaning not root, and the current node is the right child of the parent node, keep going up
      {
        currentNode = parentNode;        // set the current node to the parent node
        parentNode = parentNode->parent; // set the parent node to the parent of the parent node
      }

      return parentNode; // return the parent node
    }
  }

  // predecessor backend function that takes a node pointer as an argument and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  BSTnodePtr predecessorBackend(BSTnodePtr currentNode)
  {
    if (currentNode->left != nullptr) // if the left child is not null, then the predecessor is the maximum of the left subtree
    {
      return maximumBackend(currentNode->left);
    }
    else
    {
      BSTnodePtr parentNode = currentNode->parent; // else the predecessor is the lowest ancestor of the current node whose right child is also an ancestor of the current node

      while (parentNode != nullptr && currentNode == parentNode->left) // while the parent node is not null meaning not root, and the current node is the left child of the parent node, keep going up
      {
        currentNode = parentNode;        // set the current node to the parent node
        parentNode = parentNode->parent; // set the parent node to the parent of the parent node
      }

      return parentNode; // return the parent node
    }
  }

  // searchTree backend function that takes a node pointer and an integer key as arguments and returns a node pointer. This function is private and is only called by the public functions that act as an API in the OOP sense
  BSTnodePtr searchTreeBackend(BSTnodePtr node, const int &key)
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

  // insert backend function that takes a string name and an integer key as arguments and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void insertBackend(std::string name, int key)
  {
    BSTnodePtr node = new BST::Node(key, name); // creating a new node with the key and name

    BSTnodePtr possibleParent = nullptr; // creating a node pointer possibleParent that will be used to keep track of the parent of the node we are inserting
    BSTnodePtr currentNode = this->root; // creating a node pointer currentNode that will be used to traverse the tree

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
  }

  // transplant function that takes two node pointers as arguments and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void transplant(BSTnodePtr currentNode, BSTnodePtr replacementNode)
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

  // deleteNode backend function that takes an integer key as an argument and returns nothing. This function is private and is only called by the public functions that act as an API in the OOP sense
  void deleteNodeBackend(int key)
  {
    BSTnodePtr targetNode = nullptr;

    targetNode = searchTreeBackend(this->root, key); // Search for the node with the specified key in the tree.

    if (targetNode == nullptr) // If the target node is not found, I print and error message and return since I can't delete.
    {
      std::cout << "Key " << key << " is not in the tree. Thus deleting is impossible" << std::endl;
      return;
    }

    if (targetNode->left == nullptr) // If the target node has no left child, replace it with its right child.
    {
      transplant(targetNode, targetNode->right);
    }
    else if (targetNode->right == nullptr) // If the target node has no right child, replace it with its left child.
    {
      transplant(targetNode, targetNode->left);
    }
    else // If the target node has both left and right children, find its successor.
    {
      BSTnodePtr successorNode = minimumBackend(targetNode->right);

      if (successorNode != targetNode->right) // If the successor is not the right child of the target node, replace the successor with its right child.
      {
        transplant(successorNode, successorNode->right);
        successorNode->right = targetNode->right;
        successorNode->right->parent = successorNode;
      }

      transplant(targetNode, successorNode); // Replace the target node with its successor.
      successorNode->left = targetNode->left;
      successorNode->left->parent = successorNode;
    }
  }
};