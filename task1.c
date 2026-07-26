#include <iostream>
#include <vector>

using namespace std;

int main()
{
    int N;

    cout << "Введите размер массива: ";
    cin >> N;

    vector<int> A(N);

    cout << "Введите элементы массива:" << endl;

    for (int i = 0; i < N; i++)
        cin >> A[i];

    int minIndex = 0;
    int maxIndex = 0;

    for (int i = 1; i < N; i++)
    {
        if (A[i] < A[minIndex])
            minIndex = i;

        if (A[i] > A[maxIndex])
            maxIndex = i;
    }

    if (minIndex > maxIndex)
        swap(minIndex, maxIndex);

    int sum = 0;

    for (int i = minIndex + 1; i < maxIndex; i++)
    {
        if (A[i] < 0)
            sum += A[i];
    }

    cout << endl;
    cout << "Сумма отрицательных элементов = " << sum << endl;

    return 0;
}